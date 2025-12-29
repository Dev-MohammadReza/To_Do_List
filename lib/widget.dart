import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/icons/icons8-null-symbol-64.png',width: 120,),
        const  Text('No Task, Add new Task for Today.')
      ],
    );
  }
}



class IconScreen extends StatelessWidget {
  final bool value;
  final Function() onTap;
  const IconScreen({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: !value ? Border.all(color: Colors.black, width: 2) : null,
          color: value ? Theme.of(context).colorScheme.primary : null,
        ),
        child: value
            ? const Icon(
          CupertinoIcons.checkmark_alt,
          color: Colors.white,
          size: 15,
        )
            : null,
      ),
    );
  }
}