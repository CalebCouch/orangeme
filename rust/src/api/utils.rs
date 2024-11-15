use super::Error;

use super::pub_structs::{Usd, Btc, Sats, SATS, KeyPress, Thread, WalletMethod};
use super::simple::rustCall;

pub async fn updateDisplayAmount(
    amount: String, balance: Usd, price: Usd, input: KeyPress
) -> Result<(String, f64, u8, bool, String), Error> {
    let is_zero = || amount == "0";
    let zero = "0".to_string();

    let (updated_amount, validation) = match input {
        KeyPress::Reset => ("0".to_string(), true),
        KeyPress::Backspace => {
            if is_zero() {
                (zero, false)
            } else if amount.len() == 1 {
                (zero, true)
            } else {
                (amount[..amount.len() - 1].to_string(), true)
            }
        },
        KeyPress::Decimal => {
            if !amount.contains('.') && amount.len() <= 7 {
                (format!("{}{}", amount, "."), true)
            } else {
                (amount.clone(), false)
            }
        },
        input => {
            let input = input as i64;
            if is_zero() {
                (input.to_string(), true)
            } else if amount.contains('.') {
                let split: Vec<&str> = amount.split('.').collect();
                if amount.len() < 11 && split[1].len() < 2 {
                    (format!("{}{}", amount, input), true)
                } else {
                    (amount.clone(), false)
                }
            } else if amount.len() < 10 {
                (format!("{}{}", amount, input), true)
            } else {
                (amount.clone(), false)
            }
        }
    };

    let needed_placeholder = if updated_amount.contains('.') {
        let split: Vec<&str> = updated_amount.split('.').collect();
        2-split.get(1).unwrap_or(&"").len() as u8
    } else {0};

    let updated_amount_usd = updated_amount.parse::<Usd>().unwrap_or(0.0);
    let amount_btc = updated_amount_usd / price;
    let amount_sats = (amount_btc * SATS as Btc) as Sats;

    let min: Usd = serde_json::from_str::<(Usd, Usd)>(&rustCall(Thread::Wallet(WalletMethod::GetFees(amount_sats, price))).await?)?.1;
    let max = balance - min;

    let err: String = if updated_amount_usd != 0.0 {
        if max <= 0.0 {
            Some("You have no bitcoin".to_string())
        } else if updated_amount_usd < min {
            Some(format!("${:.2} minimum", min))
        } else if updated_amount_usd > max {
            Some(format!("${:.2} maximum", max))
        } else {
            None
        }
    } else {None}.unwrap_or_default();

    Ok((updated_amount, amount_btc, needed_placeholder, validation, err))
}
