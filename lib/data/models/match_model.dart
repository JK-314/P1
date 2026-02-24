class MatchModel {
  final String id;
  final String userId;
  final String targetUserId;
  final bool userAccepted;
  final bool targetAccepted;
  final DateTime createdAt;
  final DateTime? finalMatchedAt;

  MatchModel({
    required this.id,
    required this.userId,
    required this.targetUserId,
    this.userAccepted = false,
    this.targetAccepted = false,
    required this.createdAt,
    this.finalMatchedAt,
  });

  bool get isFinalMatched => userAccepted && targetAccepted;

  MatchModel copyWith({
    String? id,
    String? userId,
    String? targetUserId,
    bool? userAccepted,
    bool? targetAccepted,
    DateTime? createdAt,
    DateTime? finalMatchedAt,
  }) {
    return MatchModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      targetUserId: targetUserId ?? this.targetUserId,
      userAccepted: userAccepted ?? this.userAccepted,
      targetAccepted: targetAccepted ?? this.targetAccepted,
      createdAt: createdAt ?? this.createdAt,
      finalMatchedAt: finalMatchedAt ?? this.finalMatchedAt,
    );
  }

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      targetUserId: json['target_user_id'] as String,
      userAccepted: json['user_accepted'] as bool? ?? false,
      targetAccepted: json['target_accepted'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      finalMatchedAt: json['final_matched_at'] != null
          ? DateTime.parse(json['final_matched_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'target_user_id': targetUserId,
      'user_accepted': userAccepted,
      'target_accepted': targetAccepted,
      'created_at': createdAt.toIso8601String(),
      'final_matched_at': finalMatchedAt?.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'MatchModel(id: $id, user: $userId, target: $targetUserId, '
      'userAccepted: $userAccepted, targetAccepted: $targetAccepted, '
      'isFinalMatched: $isFinalMatched)';
}
