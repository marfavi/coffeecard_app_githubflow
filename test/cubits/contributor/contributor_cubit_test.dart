import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/cubits/contributor/contributor_cubit.dart';
import 'package:coffeecard/data/repositories/external/contributor_repository.dart';
import 'package:coffeecard/models/contributor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'contributor_cubit_test.mocks.dart';

const dummyContributors = [
  Contributor(
    name: 'name',
    avatarUrl: 'avatarUrl',
    githubUrl: 'githubUrl',
  ),
];

@GenerateMocks([ContributorRepository])
void main() {
  group('contributor cubit tests', () {
    late ContributorCubit contributorCubit;
    final repo = MockContributorRepository();

    setUp(() {
      contributorCubit = ContributorCubit(repo);
    });

    test('initial state is ContributorLoaded', () {
      expect(contributorCubit.state, const ContributorLoaded([]));
    });

    blocTest<ContributorCubit, ContributorState>(
      'getContributors emits [Loaded] when the repo returns a list of contributors',
      build: () {
        when(repo.getContributors()).thenAnswer((_) => dummyContributors);
        return contributorCubit;
      },
      act: (cubit) => cubit.getContributors(),
      expect: () => [
        const ContributorLoaded(dummyContributors),
      ],
    );

    tearDown(() {
      contributorCubit.close();
    });
  });
}