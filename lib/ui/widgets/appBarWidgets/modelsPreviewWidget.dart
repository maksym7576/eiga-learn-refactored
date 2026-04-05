import 'dart:async';

import 'package:eiga/backend/data/dto/AIModelDataDTO.dart';
import 'package:eiga/ui/widgets/appBarWidgets/modelWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModelPreviewWidget extends StatefulWidget {
  final AiModelDataDTO selectedModel;
  final List<AiModelDataDTO> otherModels;

  const ModelPreviewWidget({
    Key? key,
    required this.selectedModel,
    required this.otherModels,
  }) : super(key: key);

  @override
  _ModelPreviewWidget createState() => _ModelPreviewWidget();
}

class _ModelPreviewWidget extends State<ModelPreviewWidget> {
  late Timer _timer;
  String _remainingTime = '00:00:00';
  final int resetHourUTC = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now().toUtc();
    DateTime resetTime = DateTime(
      now.year,
      now.month,
      now.day,
      resetHourUTC,
      0,
      0,
    ).toUtc();

    if (!now.isBefore(resetTime)) {
      resetTime = resetTime.add(const Duration(days: 1));
    }

    final remaining = resetTime.difference(now);
    setState(() {
      _remainingTime = _formatDuration(remaining);
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return '00:00:00';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      'Models',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.deepPurpleAccent,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Select the model',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.deepPurpleAccent.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Reset in $_remainingTime',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 0),
                  child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Icon(Icons.close, size: 27, color: Colors.black87),
                ),
              ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                ModelWidget(modelDTO: widget.selectedModel, isActive: true),
                ...widget.otherModels.map((model) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ModelWidget(modelDTO: model, isActive: false),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
