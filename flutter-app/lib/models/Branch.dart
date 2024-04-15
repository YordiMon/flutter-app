class Branch {
  final int id;
  final String branchTitle;
  final String branchContent;
  final int historyId;

  Branch({
    required this.id,
    required this.branchTitle,
    required this.branchContent,
    required this.historyId
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      branchTitle: json['branch_title'],
      branchContent: json['branch_content'],
      historyId: json['history_id'],
    );
  }
}
