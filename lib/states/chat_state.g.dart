// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatState on _ChatState, Store {
  final _$messagesAtom = Atom(name: '_ChatState.messages');

  @override
  Map<String, dynamic> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(Map<String, dynamic> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  final _$_ChatStateActionController = ActionController(name: '_ChatState');

  @override
  void refreshChatsForCurrentUser() {
    final _$actionInfo = _$_ChatStateActionController.startAction(
        name: '_ChatState.refreshChatsForCurrentUser');
    try {
      return super.refreshChatsForCurrentUser();
    } finally {
      _$_ChatStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
messages: ${messages}
    ''';
  }
}
