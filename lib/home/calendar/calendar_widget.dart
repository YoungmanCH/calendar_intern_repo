import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'popup/function/show/pop_show_function.dart';

Widget CalendarFunc(WidgetRef ref, DateTime dateCalen){

  return FutureBuilder(
    future: scheJudgeFunc2(ref, dateCalen),
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      //nullの場合は、下記のように実装する。
      if (snapshot.data ?? false) {
        return Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }else {
        //何もない場合は、空のSizedBox()　を用いる。
        return const SizedBox();
      }
    },
  );
} 