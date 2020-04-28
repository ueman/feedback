/// See https://docs.gitlab.com/ee/api/projects.html#upload-a-file
class FileUploadResponse {
  FileUploadResponse({this.alt, this.url, this.fullPath, this.markdown});

  factory FileUploadResponse.fromJson(Map json) {
    return FileUploadResponse(
      alt: json['alt'] as String,
      url: json['url'] as String,
      fullPath: json['full_path'] as String,
      markdown: json['markdown'] as String,
    );
  }

  final String alt;
  final String url;
  final String fullPath;
  final String markdown;
}
