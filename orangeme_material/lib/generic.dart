
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:async';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:orange/global.dart' as global;
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/error.dart';


abstract class GenericWidget extends StatefulWidget {
    Timer? timer;
    CancelableOperation<String>? async_state;

    GenericWidget({super.key});
}

abstract class GenericState<T extends GenericWidget> extends State<T> {
    PageName getPageName();
    int refreshInterval();
    Widget build_with_state(BuildContext context);

    void unpack_state(Map<String, dynamic> json);

    void getState() async {
        int time = DateTime.now().millisecondsSinceEpoch;
        widget.async_state = CancelableOperation.fromFuture(
            getPage(path: global.dataDir!, page: getPageName()),
        );
        widget.async_state!.then((String state) {
            unpack_state(jsonDecode(state));
            _createTimer();
        });
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder<String>(
            future: widget.async_state?.value,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                    return build_with_state(context);
                } else {
                    return Container();
                }
            }
        );
    }

    navigateTo(Widget next) async {
        widget.async_state?.cancel();
        widget.timer?.cancel();
        await global.navigation.navigateTo(next);
        await _createTimer();
    }

    _createTimer() {
        widget.timer?.cancel();
        var interval = refreshInterval();
        if (interval > 0) {
            widget.timer = Timer(Duration(milliseconds: interval), () {
                getState();
            });
        }
    }

    @override
    void initState() {
        getState();
        super.initState();
    }

    @override
    void dispose() {
        widget.async_state?.cancel();
        widget.timer?.cancel();
        super.dispose();
    }
}