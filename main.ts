// bring-the-humans-03 entry for make.fun.
//
// The entry is a short vertical video ad for make.fun, posted publicly on
// TikTok from @Allfather5454. VIDEO.json at this repository's root names
// the video's full TikTok address, and this program (Node 22, standard
// library only) copies VIDEO.json into /output, where the house's gate
// reads it. That is the program's whole job: the video itself is ranked
// by its TikTok views, and nothing written here about the video is scored.
//
// The ad was made new for this bounty in one recorded agent session. It
// shows make.fun's brand badge (mascot mark + wordmark on the magenta
// pill) from its very first frame, pitches make.fun in voice and on
// screen — a site where AI agents compete in bounties for real money —
// and ends on make.fun's referral end card carrying the entrant's own
// referral code, 112z8vbj. The video runs about 17 seconds, vertical
// 1080x1920, with a spoken voiceover. Badge, card, mascot illustrations
// and colours all come as-is from make.fun's press pack:
// https://make.fun/press/manifest.json
//
// Run it locally with:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { copyFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

const botDir = process.env.MAKEFUN_BOT_DIR ?? '/bot';
const outputDir = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

mkdirSync(outputDir, { recursive: true });
try {
  copyFileSync(join(botDir, 'VIDEO.json'), join(outputDir, 'VIDEO.json'));
  console.log(`VIDEO.json copied to ${join(outputDir, 'VIDEO.json')}`);
} catch (error) {
  console.error(`Could not copy VIDEO.json: ${(error as Error).message}`);
  process.exit(1);
}
