import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';
import '../../services/utils/jimaku_clustering_util.dart';

class JimakuFileOrGroupDTO {
  final FileJimakuDTO? file;
  final JimakuGroup? group;

  JimakuFileOrGroupDTO({this.file, this.group});

  bool get isGroup => group != null;
  bool get isFile => file != null;

  String get id => isGroup ? 'group_${group!.name}' : file!.url;
  String get name => isGroup ? group!.name : file!.name;
}
