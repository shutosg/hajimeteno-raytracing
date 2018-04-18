class Timer {
  int startTime;
  
  float progress;
  int remainingSec;
  Timer() {
    //
  }

  void start() {
    startTime = millis();
  }
  
  void update(float progress) {
    this.progress = progress;
    int elapsedSec = (millis() - startTime) / 1000;
    remainingSec = (int)(elapsedSec / progress * (1 - progress));
  }

  String getPrintOut() {
    return String.format("%.4f %% Remaining: %dh %dm %ds", progress * 100, remainingSec / 3600, remainingSec % 3600 / 60, remainingSec % 60);
  }

  String getFinalPrintOut() {
    int resultSec = (millis() - startTime) / 1000;
    return String.format("Render Time: %dh %dm %ds", resultSec / 3600, resultSec % 3600 / 60, resultSec % 60);
  }
}