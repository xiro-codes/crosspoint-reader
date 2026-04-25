#pragma once

#include "components/themes/lyra/LyraTheme.h"

class GfxRenderer;

namespace LyraBigCoverMetrics {
constexpr ThemeMetrics values = [] {
  ThemeMetrics v = LyraMetrics::values;
  v.homeCoverHeight = 380;
  v.homeCoverTileHeight = 380;
  v.homeRecentBooksCount = 1;
  return v;
}();
}  // namespace LyraBigCoverMetrics

class LyraBigCoverTheme : public LyraTheme {
 private:
  mutable int coverWidth = 0;

 public:
  void drawRecentBookCover(GfxRenderer& renderer, Rect rect, const std::vector<RecentBook>& recentBooks,
                           const int selectorIndex, bool& coverRendered, bool& coverBufferStored, bool& bufferRestored,
                           std::function<bool()> storeCoverBuffer) const override;
};
