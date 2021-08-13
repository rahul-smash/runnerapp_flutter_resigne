import 'dart:io';

class WorkDetailDocumentModel{
  File file;
  var fileSize;
  bool isImageUrl;
  WorkDetailDocumentModel(this.file, this.fileSize,{this.isImageUrl = false});
}