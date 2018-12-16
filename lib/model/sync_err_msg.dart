class SyncErrorMessage {
	final bool hasProblem;
	final String errorDesc;

	SyncErrorMessage(this.hasProblem , this.errorDesc);

	SyncErrorMessage.empty():
			this.hasProblem = false,
			this.errorDesc = '';
}