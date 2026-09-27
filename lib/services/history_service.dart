import '../models/track.dart';

class HistoryService {
  final List<SequencerState> _history = [];
  final List<SequencerState> _redoStack = [];
  int _currentIndex = -1;
  static const int maxHistory = 50;

  void pushState(SequencerState state) {
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }

    _history.add(state);
    if (_history.length > maxHistory) {
      _history.removeAt(0);
    } else {
      _currentIndex++;
    }

    _redoStack.clear();
  }

  SequencerState? undo() {
    if (_currentIndex > 0) {
      _currentIndex--;
      return _history[_currentIndex];
    }
    return null;
  }

  SequencerState? redo() {
    if (_currentIndex < _history.length - 1) {
      _currentIndex++;
      return _history[_currentIndex];
    }
    return null;
  }

  bool get canUndo => _currentIndex > 0;
  bool get canRedo => _currentIndex < _history.length - 1;

  void clear() {
    _history.clear();
    _redoStack.clear();
    _currentIndex = -1;
  }
}
