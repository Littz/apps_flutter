import 'package:edagang/deeplink/deeplink_bloc.dart';
import 'package:edagang/deeplink/deeplink_widget.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Index extends StatelessWidget {
  final MainScopedModel _model = MainScopedModel();

  @override
  Widget build(BuildContext context) {

    DeepLinkBloc _bloc = DeepLinkBloc();
    return Scaffold(
        body: Provider<DeepLinkBloc>(
            builder: (context) => _bloc,
            dispose: (context, bloc) => bloc.dispose(),
            child: DeeplinkWidget()
        )
    );
  }

}