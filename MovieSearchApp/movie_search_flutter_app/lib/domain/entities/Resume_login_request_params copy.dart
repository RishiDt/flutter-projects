class ResumeLoginRequestParams {
  final String sessionId;

  ResumeLoginRequestParams({required this.sessionId});

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
      };
}
