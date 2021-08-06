import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/account_steps_detail_model.dart';

abstract class AccountStepsDetailRepository {

  Future<AccountStepsDetailModel> getAccountStepsDetail(String userd);

}