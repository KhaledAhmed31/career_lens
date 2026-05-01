// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:career_lens/core/config/di/di_modules.dart' as _i756;
import 'package:career_lens/features/input/data/datasources/skill_search_data_source.dart'
    as _i598;
import 'package:career_lens/features/input/data/datasources/user_skills_data_source.dart'
    as _i511;
import 'package:career_lens/features/input/data/repositories/skill_search_repo_impl.dart'
    as _i912;
import 'package:career_lens/features/input/domain/repositories/skill_search_repo.dart'
    as _i199;
import 'package:career_lens/features/input/domain/usecases/search_for_skill_use_case.dart'
    as _i580;
import 'package:career_lens/features/input/presentation/cubit/input_cubit.dart'
    as _i597;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i598.SkillSearchDataSource>(
      () => _i598.SkillSearchDataSource(),
    );
    gh.singleton<_i199.SkillSearchRepo>(
      () => _i912.SkillSearchRepoImpl(gh<_i598.SkillSearchDataSource>()),
    );
    gh.singleton<_i511.UserSkillsDataSource>(
      () => _i511.UserSkillsDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i580.GetAllSkillSUseCase>(
      () => _i580.GetAllSkillSUseCase(gh<_i199.SkillSearchRepo>()),
    );
    gh.lazySingleton<_i597.InputCubit>(
      () =>
          _i597.InputCubit(getallSkillUseCase: gh<_i580.GetAllSkillSUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i756.RegisterModule {}
