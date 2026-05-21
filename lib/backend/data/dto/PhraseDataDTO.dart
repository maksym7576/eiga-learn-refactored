

import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';

class PhraseDataDTO {
  final List<BlockObject> blocks;
  final List<WordObject> allOriginalWords;

  PhraseDataDTO(this.blocks, this.allOriginalWords);
}