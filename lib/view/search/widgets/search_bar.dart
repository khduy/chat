import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.onChanged,
    required this.onCancle,
  }) : super(key: key);

  final void Function(String) onChanged;
  final VoidCallback onCancle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            onChanged: (value) => onChanged(value),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.all(8.0),
              fillColor: theme.brightness == Brightness.light ? Colors.black12 : Colors.white12,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.search,
                  color: theme.hintColor,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(maxHeight: 50, maxWidth: 50),
              hintText: 'Enter user name',
            ),
          ),
        ),
        CupertinoButton(
          child: const Text('Cancle'),
          onPressed: onCancle,
          padding: const EdgeInsets.all(8),
        ),
      ],
    );
  }
}
