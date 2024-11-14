//  pub async fn updateDisplayAmount(path: String, input: &str) -> String {
//      let result: Result<String, Error> = (|| async {
//          let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
//          let amount = state.get::<String>(Field::Amount).await?;
//          let btc = state.get::<f64>(Field::Balance).await?;
//          let price = state.get::<f64>(Field::Price).await?;
//          let usd_balance = btc*price;
//          let min: f64 = 0.30;
//          let max = usd_balance - min;

//          let (updated_amount, validation) = match input {
//              "reset" => ("0".to_string(), true),
//              "backspace" => {
//                  if amount == "0" {
//                      (amount.clone(), false)
//                  } else if amount.len() == 1 {
//                      ("0".to_string(), true)
//                  } else {
//                      (amount[..amount.len() - 1].to_string(), true)
//                  }
//              },
//              "." => {
//                  if !amount.contains('.') && amount.len() <= 7 {
//                      (format!("{}{}", amount, "."), true)
//                  } else {
//                      (amount.clone(), false)
//                  }
//              },
//              _ => {
//                  if amount == "0" {
//                      (input.to_string(), true)
//                  } else if amount.contains('.') {
//                      let split: Vec<&str> = amount.split('.').collect();
//                      if amount.len() < 11 && split[1].len() < 2 {
//                          (format!("{}{}", amount, input), true)
//                      } else {
//                          (amount.clone(), false)
//                      }
//                  } else if amount.len() < 10 {
//                      (format!("{}{}", amount, input), true)
//                  } else {
//                      (amount.clone(), false)
//                  }
//              }
//          };

//          let decimals = if updated_amount.contains('.') {
//              let split: Vec<&str> = updated_amount.split('.').collect();
//              let decimals_len = split.get(1).unwrap_or(&"").len();
//              if decimals_len < 2 {
//                  "0".repeat(2 - decimals_len)
//              } else {
//                  String::new()
//              }
//          } else {
//              String::new()
//          };

//          let updated_amount_f64 = updated_amount.parse::<f64>().unwrap_or(0.0);

//          let err: Option<String> = if updated_amount_f64 != 0.0 {
//              if max <= 0.0 {
//                  Some("You have no bitcoin".to_string())
//              } else if updated_amount_f64 < min {
//                  Some(format!("${:.2} minimum", min))
//              } else if updated_amount_f64 > max {
//                  Some(format!("${:.2} maximum", max))
//              } else {
//                  None
//              }
//          } else {
//              None
//          };

//          state.set(Field::Amount, &updated_amount).await?;
//          state.set(Field::AmountBTC, &(updated_amount_f64 / price)).await?;
//          state.set(Field::AmountErr, &err).await?;
//          state.set(Field::Decimals, &decimals).await?;
//          Ok(if validation { "true".to_string() } else { "false".to_string() })
//      })().await;

//      match result {
//          Ok(validation_str) => validation_str,
//          Err(e) => format!("Error: {}", e),
//      }
//  }
