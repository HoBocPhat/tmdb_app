abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus{
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus{}

class FormEditing extends FormSubmissionStatus{}

class SubmissionSuccess extends FormSubmissionStatus{}

class SubmissionFailed extends FormSubmissionStatus{
  final String exception;

  SubmissionFailed(this.exception);
}