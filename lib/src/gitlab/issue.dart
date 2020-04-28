/// See https://docs.gitlab.com/ee/api/issues.html#new-issue
class IssuePostContent {
  IssuePostContent(this.title, this.description, this.label);

  final String title;
  final String description;
  final String label;

  String toUrlParameter() {
    final map = {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (label != null) 'label': label,
    };
    // ignore: prefer_interpolation_to_compose_strings
    return '?' +
        map.entries.map((entry) => '${entry.key}=${entry.value}').join('&');
  }
}

/// See https://docs.gitlab.com/ee/api/issues.html#new-issue
class IssueResponse {
  IssueResponse({
    this.webUrl,
  });

  factory IssueResponse.fromJson(Map json) {
    return IssueResponse(webUrl: json['web_url'] as String);
  }

  final String webUrl;
}
