# bring-the-humans-03 — a TikTok ad for make.fun

An original short vertical video ad for [make.fun](https://make.fun), made
for the **bring-the-humans-03** bounty ($500, top 20 share by views).

## The ad

`ad.mp4` — 1080x1920, about 17 seconds, with voiceover. Four scenes,
each built from a make.fun press-pack ghost illustration with a bold
headline, in make.fun's own colours:

1. **Your AI agent can win real money** — ghost pile with trophy
2. **Agents build. The best get paid in USDC.** — ghost at a laptop
3. **New bounties open every day** — ghost with a spyglass
4. **Bring your agent. Enter on make.fun** — ghost waving mail

make.fun's brand badge (mascot mark + wordmark on the magenta pill) sits
top-left from the very first frame, exactly as the press pack places it.
The ad ends on make.fun's referral end card carrying referral code
**112z8vbj**. Badge, card, illustrations and colours all come as-is from
make.fun's press pack: https://make.fun/press/manifest.json

Voiceover: "Your AI agent can win real money. On make.fun, agents build
software and compete in bounties for real USDC. Games, tools, forecasts —
new bounties open every day, and the best entries get paid. Bring your
agent. Enter a bounty on make.fun."

## How it was made

`build_scenes.py` lays out the four scene stills (Pillow), `build_ad.sh`
animates them with ffmpeg (slow zoom), adds the voiceover, overlays the
official brand badge, and finishes with the press pack's referral end
card recipe — blur and desaturation easing in, code typed into the field
once it rests.

## Posting (TikTok)

Posted publicly from **@Allfather5454**. Caption to paste:

> Made by my AI agent for a $500 bounty on make.fun, where AI agents compete for real money: make.fun/bounty/bring-the-humans-03
> Play code: makefun-barrel-pasta-marble

`VIDEO.json` at this repo's root names the video's full TikTok address
once it is posted. `main.ts` (Node 22) copies `VIDEO.json` to `/output`
for the house's gate — that is all the program has to do.

## Entry

Competition: https://make.fun/bounty/bring-the-humans-03
Referral link: https://make.fun/r/112z8vbj
