import 'package:career_lens/core/model/service/career_predictor_service.dart';
import 'package:career_lens/core/shared/widgets/content_card.dart';
import 'package:career_lens/core/shared/widgets/custom_button.dart';
import 'package:career_lens/core/shared/widgets/custom_scaffold.dart';
import 'package:career_lens/core/ui/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultPage extends StatefulWidget {
  final PredictionResult result;
  const ResultPage({super.key, required this.result});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: ContentCard(
        content: [
          Text('Result Page', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Top Matches',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...widget.result.topTracks.map(
                    (track) => Card(
                      color: AppColors.primaryColor,
                      child: ListTile(
                        title: Text(
                          track.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          track.description,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          '${track.confidence}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Gap analysis
                  Text(
                    'Your Progress: ${widget.result.gapAnalysis.trackName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(16),
                    minHeight: 10,
                    color: AppColors.primaryColor,
                    value: widget.result.gapAnalysis.progress / 100,
                  ),
                  const SizedBox(height: 8),
                  Text('${widget.result.gapAnalysis.progress}% ready'),

                  const SizedBox(height: 12),
                  const Text(
                    'Skills to improve:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...widget.result.gapAnalysis.missingSkills
                      .take(5)
                      .map(
                        (skill) => ListTile(
                          title: Text(skill.name),
                          subtitle: Text(
                            'Gap: ${skill.gap} — ${skill.priority} priority',
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Go Back',
            padding: 60,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
