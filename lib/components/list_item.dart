import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/flows/bitcoin/transactions/transaction_details.dart';
import 'package:orange/flows/bitcoin/transactions/unconfirmed_transaction.dart';

import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/profile_photo.dart';

import 'package:orange/classes.dart';
import 'package:orange/temp_classes.dart';
import 'package:orange/util.dart';

// This file defines several types of list items:
// DefaultListItem for general use with customizable sections,
// ImageListItem for items featuring images, and specific item builders such as
// messageListItem for conversation messages and contactListItem for displaying contacts.

class DefaultListItem extends StatelessWidget {
  final Widget? topLeft;
  final Widget? bottomLeft;
  final Widget? topRight;
  final Widget? bottomRight;
  final VoidCallback? onTap;

  const DefaultListItem({
    super.key,
    this.topLeft,
    this.bottomLeft,
    this.topRight,
    this.bottomRight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        if (onTap != null) onTap!();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.listItem),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (topLeft != null) topLeft!,
                    if (bottomLeft != null) bottomLeft!,
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (topRight != null) topRight!,
                if (bottomRight != null) bottomRight!,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* A list item widget designed to display an image on the left. */
class ImageListItem extends StatelessWidget {
  final Widget? left;
  final Widget? topLeft;
  final Widget? bottomLeft;
  final Widget? topRight;
  final Widget? bottomRight;
  final VoidCallback? onTap;

  const ImageListItem({
    super.key,
    this.left,
    this.topRight,
    this.bottomRight,
    this.topLeft,
    this.bottomLeft,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        if (onTap != null) onTap!();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.listItem),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: (left != null) ? left! : Container(),
            ),
            const Spacing(width: AppPadding.listItem),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (topLeft != null) topLeft!,
                  if (bottomLeft != null) bottomLeft!,
                ],
              ),
            ),
            topRight != null || bottomRight != null
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (topRight != null) topRight!,
                        if (bottomRight != null) bottomRight!,
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

/* Constructs a list item for displaying a conversation */
Widget messageListItem(
    BuildContext context, Conversation convo, VoidCallback onTap) {
  bool isGroup = false;
  String listNames = '';
  if (convo.members.length > 1) isGroup = true;
  for (var contact in convo.members) {
    if (listNames.isEmpty) {
      listNames = contact.name;
    } else {
      listNames = '$listNames, ${contact.name}';
    }
  }

  return ImageListItem(
    onTap: onTap,
    left: Container(
      alignment: Alignment.centerLeft,
      child: profilePhoto(
        context,
        isGroup ? null : convo.members[0].pfp,
        'group',
        ProfileSize.lg,
        false,
      ),
    ),
    topLeft: CustomText(
      text: isGroup ? 'Group message' : convo.members[0].name,
      textSize: TextSize.md,
    ),
    bottomLeft: convo.messages.isNotEmpty
        ? CustomText(
            trim: true,
            alignment: TextAlign.left,
            text: isGroup ? listNames : convo.messages.last.message,
            textSize: TextSize.sm,
            color: ThemeColor.textSecondary,
            maxLines: 2,
          )
        : CustomText(
            trim: true,
            alignment: TextAlign.left,
            text: listNames,
            textSize: TextSize.sm,
            color: ThemeColor.textSecondary,
            maxLines: 2,
          ),
  );
}

/* List item for showing contact information, including a profile photo,
 the contact's name, and a truncated version of the contact's DID. */
Widget contactListItem(BuildContext context, Contact contact, onTap) {
  return ImageListItem(
    onTap: onTap,
    left: Container(
      alignment: Alignment.centerLeft,
      child: profilePhoto(context, contact.pfp, null, ProfileSize.lg),
    ),
    topLeft: CustomText(
      text: contact.name,
      textSize: TextSize.md,
    ),
    bottomLeft: CustomText(
      text: middleCut(contact.did, 30),
      textSize: TextSize.sm,
      color: ThemeColor.textSecondary,
    ),
  );
}

Widget walletListItem(BuildContext context, Wallet wallet, onTap) {
  return ImageListItem(
    onTap: onTap,
    left: Container(
      alignment: Alignment.centerLeft,
      child: profilePhoto(context, null, 'wallet', ProfileSize.lg),
    ),
    topLeft: CustomText(
      text: wallet.name,
      textSize: TextSize.h5,
      textType: 'heading',
    ),
    bottomLeft: CustomText(
      text: wallet.isSpending ? 'Spending' : 'Savings',
      textSize: TextSize.sm,
      color: ThemeColor.textSecondary,
    ),
    topRight: CustomText(
      text: "\$${formatValue(wallet.balance)}",
      textSize: TextSize.h5,
      textType: 'heading',
    ),
    bottomRight: CustomText(
      text: "${wallet.btc} BTC",
      textSize: TextSize.sm,
      color: ThemeColor.textSecondary,
    ),
  );
}

Widget transactionListItem(GlobalState globalState, BuildContext context,
    Transaction transaction, bool pendingConfirmation) {
  return DefaultListItem(
    onTap: () {
      if (pendingConfirmation) {
        navigateTo(context, UnconfirmedTransaction(globalState, transaction));
      } else {
        navigateTo(context, TransactionDetailsWidget(globalState, transaction));
      }
    },
    topLeft: Row(children: [
      CustomText(
        alignment: TextAlign.left,
        textType: "text",
        textSize: TextSize.md,
        text: pendingConfirmation
            ? "Sending bitcoin"
            : transaction.isReceive
                ? "Received bitcoin"
                : "Sent bitcoin",
        color: pendingConfirmation ? ThemeColor.warning : ThemeColor.text,
      ),
      const Spacing(width: 8),
      const CustomIcon(
        icon: ThemeIcon.warning,
        iconColor: ThemeColor.warning,
        iconSize: IconSize.sm,
      ),
    ]),
    bottomLeft: CustomText(
      alignment: TextAlign.left,
      textSize: TextSize.sm,
      color: ThemeColor.textSecondary,
      text: formatDate(transaction.date, transaction.time),
    ),
    topRight: CustomText(
      alignment: TextAlign.right,
      textSize: TextSize.md,
      text: "\$${formatValue((transaction.usd).abs())}",
    ),
    bottomRight: const CustomText(
      alignment: TextAlign.right,
      textSize: TextSize.sm,
      color: ThemeColor.textSecondary,
      text: "Details",
      underline: true,
    ),
  );
}
