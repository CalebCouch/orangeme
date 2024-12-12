
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:async/async.dart';

import 'package:orange/global.dart' as global;
import 'package:flow_bitcoin/flow_bitcoin.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/src/rust/api/simple.dart';


abstract class GenericWidget extends StatefulWidget {
    CancelableCompleter? completer;
    Timer? timer;
    bool connected = false;
    bool running = true;
    bool init = true;
    ValueNotifier<String> state_notifier = ValueNotifier("");

    GenericWidget({super.key});
}

abstract class GenericState<T extends GenericWidget> extends State<T> {
    PageName getPageName();

    Widget build_with_state(BuildContext context);

    void unpack_state(Map<String, dynamic> json);

    int refreshInterval() {return 80;}

    Future<String> getStateAsync() async {
        widget.state_notifier.value = await getPage(path: global.dataDir!, page: getPageName());
        _createTimer();
        return "DONE";
    }

    void handleState(String state) {
        var json = jsonDecode(state);
        widget.connected = json["connected"] as bool;
        if (!widget.connected && getPageName() != PageName.bitcoinHome()) {
            global.navigation.resetNavTo(BitcoinHome());
        }
        unpack_state(jsonDecode(json["state"] as String));
        widget.init = false;
    }

    void getState() async {
        widget.completer = CancelableCompleter(onCancel: () {
            print('CANCELED FUTURE');
        });
        widget.completer?.complete(getStateAsync());
    }

    @override
    Widget build(BuildContext context) {
        return ValueListenableBuilder(
            valueListenable: widget.state_notifier,
            builder: (BuildContext context, String state, Widget? child) {
                print("BUILD: ${getPageName()}, state: ${state}");
                if (state == "") {
                    return Container();
                } else {
                    handleState(state);
                    return build_with_state(context);
                }
            }
        );
    }

    bool isConnected() {return widget.connected;}

    navigateTo(Widget next) async {
        widget.completer?.operation.cancel();
        widget.running = false;
        await global.navigation.navigateTo(next);
         _createTimer();
        widget.running = true;
    }

    _createTimer() {
        var interval = refreshInterval();
        if (interval > 0 && widget.running) {
            widget.timer = Timer(Duration(milliseconds: interval), () {
                getState();
            });
        }
    }

    @override
    void initState() {
        print("PAGE INIT: ${getPageName()}");
        getState();
        super.initState();
    }

    @override
    void dispose() {
        widget.completer?.operation.cancel();
        widget.running = false;
        super.dispose();
    }
}
