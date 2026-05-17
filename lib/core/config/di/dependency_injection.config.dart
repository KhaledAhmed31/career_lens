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
import 'package:career_lens/features/input/data/repositories/user_skills_repo_impl.dart'
    as _i376;
import 'package:career_lens/features/input/domain/repositories/skill_search_repo.dart'
    as _i199;
import 'package:career_lens/features/input/domain/repositories/user_skills_repo.dart'
    as _i486;
import 'package:career_lens/features/input/domain/usecases/add_skills_use_case.dart'
    as _i747;
import 'package:career_lens/features/input/domain/usecases/get_user_skills_use_case.dart'
    as _i396;
import 'package:career_lens/features/input/domain/usecases/remove_user_skill_use_case.dart'
    as _i919;
import 'package:career_lens/features/input/domain/usecases/search_for_skill_use_case.dart'
    as _i580;
import 'package:career_lens/features/input/domain/usecases/update_skill_proficiency_use_case.dart'
    as _i129;
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
    gh.lazySingleton<_i486.UserSkillsRepo>(
      () => _i376.UserSkillsRepoImpl(gh<_i511.UserSkillsDataSource>()),
    );
    gh.lazySingleton<_i747.AddSkillsUseCase>(
      () => _i747.AddSkillsUseCase(gh<_i486.UserSkillsRepo>()),
    );
    gh.lazySingleton<_i129.UpdateSkillProficiencyUseCase>(
      () => _i129.UpdateSkillProficiencyUseCase(gh<_i486.UserSkillsRepo>()),
    );
    gh.lazySingleton<_i580.GetSkillsListForSearchUseCase>(
      () => _i580.GetSkillsListForSearchUseCase(gh<_i199.SkillSearchRepo>()),
    );
    gh.lazySingleton<_i919.RemoveUserSkillUseCase>(
      () => _i919.RemoveUserSkillUseCase(repo: gh<_i486.UserSkillsRepo>()),
    );
    gh.lazySingleton<_i396.GetUserSkillsUseCase>(
      () => _i396.GetUserSkillsUseCase(gh<_i486.UserSkillsRepo>()),
    );
    gh.lazySingleton<_i597.InputCubit>(
      () => _i597.InputCubit(
        getSearchSkillsList: gh<_i580.GetSkillsListForSearchUseCase>(),
        getUserSkillsUseCase: gh<_i396.GetUserSkillsUseCase>(),
        addSkillsUseCase: gh<_i747.AddSkillsUseCase>(),
        updateSkillProficiencyUseCase:
            gh<_i129.UpdateSkillProficiencyUseCase>(),
        removeUserSkillUseCase: gh<_i919.RemoveUserSkillUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i756.RegisterModule {}
