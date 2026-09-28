import 'dart:async';

class AutomationPoint {
  final double time;
  final double value;

  const AutomationPoint(this.time, this.value);
}

class AutomationLane {
  final String id;
  final String name;
  final String parameter;
  final List<AutomationPoint> points;
  final bool isVisible;

  const AutomationLane({
    required this.id,
    required this.name,
    required this.parameter,
    required this.points,
    this.isVisible = true,
  });

  AutomationLane copyWith({
    String? name,
    String? parameter,
    List<AutomationPoint>? points,
    bool? isVisible,
  }) {
    return AutomationLane(
      id: id,
      name: name ?? this.name,
      parameter: parameter ?? this.parameter,
      points: points ?? this.points,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  double getValueAtTime(double time) {
    if (points.isEmpty) return 0.0;
    if (points.length == 1) return points.first.value;

    for (int i = 0; i < points.length - 1; i++) {
      if (time >= points[i].time && time <= points[i + 1].time) {
        final t = (time - points[i].time) / (points[i + 1].time - points[i].time);
        return points[i].value + t * (points[i + 1].value - points[i].value);
      }
    }

    return points.last.value;
  }
}

class AutomationService {
  final List<AutomationLane> _lanes = [];
  Timer? _timer;
  double _currentTime = 0.0;
  bool _isPlaying = false;

  final _timeController = StreamController<double>.broadcast();
  Stream<double> get timeStream => _timeController.stream;

  List<AutomationLane> get lanes => _lanes;
  double get currentTime => _currentTime;
  bool get isPlaying => _isPlaying;

  void addLane(AutomationLane lane) {
    _lanes.add(lane);
  }

  void removeLane(String laneId) {
    _lanes.removeWhere((lane) => lane.id == laneId);
  }

  void updateLane(String laneId, AutomationLane Function(AutomationLane) update) {
    final index = _lanes.indexWhere((lane) => lane.id == laneId);
    if (index != -1) {
      _lanes[index] = update(_lanes[index]);
    }
  }

  void addPoint(String laneId, AutomationPoint point) {
    final index = _lanes.indexWhere((lane) => lane.id == laneId);
    if (index != -1) {
      final points = List<AutomationPoint>.from(_lanes[index].points)..add(point);
      points.sort((a, b) => a.time.compareTo(b.time));
      _lanes[index] = _lanes[index].copyWith(points: points);
    }
  }

  void removePoint(String laneId, int pointIndex) {
    final index = _lanes.indexWhere((lane) => lane.id == laneId);
    if (index != -1) {
      final points = List<AutomationPoint>.from(_lanes[index].points);
      if (pointIndex >= 0 && pointIndex < points.length) {
        points.removeAt(pointIndex);
        _lanes[index] = _lanes[index].copyWith(points: points);
      }
    }
  }

  void play() {
    if (_isPlaying) return;
    _isPlaying = true;
    _startTimer();
  }

  void pause() {
    _isPlaying = false;
    _timer?.cancel();
    _timer = null;
  }

  void stop() {
    pause();
    _currentTime = 0.0;
    _timeController.add(_currentTime);
  }

  void seek(double time) {
    _currentTime = time;
    _timeController.add(_currentTime);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _currentTime += 0.016;
      _timeController.add(_currentTime);
    });
  }

  void dispose() {
    _timer?.cancel();
    _timeController.close();
  }
}
