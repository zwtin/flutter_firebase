import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase/blocs/edit_profile_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_firebase/common/inverted_circle_clipper.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:flutter_firebase/use_cases/alert.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editProfileBloc = Provider.of<EditProfileBloc>(context);
    final tabBloc = Provider.of<TabBloc>(context);

    editProfileBloc.alertController.stream.listen(
      (Alert alert) {
        SweetAlert.show(
          context,
          title: alert.title,
          subtitle: alert.subtitle,
          style: alert.style,
          showCancelButton: alert.showCancelButton,
          onPress: alert.onPress,
        );
      },
    );

    editProfileBloc.popController.stream.listen(
      (event) {
        tabBloc.popAction();
      },
    );

    return StreamBuilder(
      stream: editProfileBloc.loadingController.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return LoadingOverlay(
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'プロフィール編集',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFFFFCC00),
              elevation: 0, // 影をなくす
              bottom: PreferredSize(
                child: Container(
                  color: Colors.white24,
                  height: 1,
                ),
                preferredSize: const Size.fromHeight(1),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(EvaIcons.checkmarkSquare),
                  onPressed: editProfileBloc.updateProfile,
                ),
              ],
            ),

            // 読み込み中インジケーターを表示できるView
            body: Stack(
              children: [
                // 背景色
                Container(
                  color: const Color(0xFFFFCC00),
                ),

                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 30,
                      ),
                      Center(
                        child: Container(
                          height: 200,
                          width: 200,
                          child: Stack(
                            children: [
                              StreamBuilder(
                                  stream:
                                      editProfileBloc.imageController.stream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> imageUrlSnapshot) {
                                    if (imageUrlSnapshot.hasData) {
                                      return Container(
                                        constraints:
                                            const BoxConstraints.expand(),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          imageUrl: imageUrlSnapshot.data,
                                          errorWidget: (context, url,
                                                  dynamic error) =>
                                              Image.asset(
                                                  'assets/icon/no_user.jpg'),
                                          fit: BoxFit.contain,
                                        ),
                                      );
                                    }
                                    return Container();
                                  }),
                              StreamBuilder(
                                stream:
                                    editProfileBloc.imageFileController.stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<File> imageFileSnapshot) {
                                  if (imageFileSnapshot.hasData) {
                                    return Container(
                                      constraints:
                                          const BoxConstraints.expand(),
                                      child: Image.file(
                                        imageFileSnapshot.data,
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                              Container(
                                child: ClipPath(
                                  clipper: InvertedCircleClipper(),
                                  child: Container(
                                    color: Color.fromRGBO(0, 0, 0, 0.5),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: editProfileBloc.getImage,
                                child: Container(),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Text('ユーザー名'),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: editProfileBloc.nameController,
                        ),
                      ),
                      const Text('一言'),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: editProfileBloc.introductionController,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isLoading: snapshot.data ?? false,
          color: Colors.grey,
        );
      },
    );
  }
}
