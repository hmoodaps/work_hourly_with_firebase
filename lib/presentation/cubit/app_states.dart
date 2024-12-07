abstract class AppStates {}

class InitState extends AppStates {}

class ToggleLightAndDark extends AppStates {}

class ChangeAppLanguage extends AppStates {}

class ResetPasswordSuccessState extends AppStates {}

class signInwWithGoogleSuccess extends AppStates {}

class LoginSuccessState extends AppStates {}

class logoutSuccessState extends AppStates {}

class startWorkSuccessState extends AppStates {}

class EndWorkSuccess extends AppStates {}

class OnBonusOrDiscountPressState extends AppStates {}
class CalculateSalary extends AppStates {}
class AddFakeDates extends AppStates {}

class UpdateBonusOrDiscount extends AppStates {}

class OnCalenderDaySelected extends AppStates {}

class GetDate extends AppStates {}

class OnItemExpanded extends AppStates {}

class DeleteItem extends AppStates {}

class AddToArchive extends AppStates {}

class GetArchivedDate extends AppStates {}

class SetLanguage extends AppStates {}

class ChangeLanguage extends AppStates {}

class IsLanguagePressed extends AppStates {}

class WorkItemExpanded extends AppStates {}

class AnimationComplete extends AppStates {}

class GetTodayWork extends AppStates {}

class OnStartAndEndWorkPress extends AppStates {}

class MainScreenStartup extends AppStates {}

class ResetPasswordErrorState extends AppStates {
  String error;

  ResetPasswordErrorState(this.error);
}

class LoginErrorState extends AppStates {
  String error;

  LoginErrorState(this.error);
}

class signInwWithGoogleError extends AppStates {
  String error;

  signInwWithGoogleError(this.error);
}

class logoutErrorState extends AppStates {
  String error;

  logoutErrorState(this.error);
}

class startWorkErrorState extends AppStates {
  String error;

  startWorkErrorState(this.error);
}

class endWorkError extends AppStates {
  String error;

  endWorkError(this.error);
}
