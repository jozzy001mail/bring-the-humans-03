#!/bin/bash
# Build the bring-the-humans-03 ad: 4 animated scenes + voiceover,
# official brand badge from frame 0, referral end card + typed code.
set -e
cd ~/workspace/makefun/bring-the-humans-03

# 1. Animated scene segments (slow zoom on each still)
ffmpeg -y -v error -i scene1.png -vf "zoompan=z='min(zoom+0.0009,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=128:s=1080x1920:fps=30" -t 4.25 -c:v libx264 -pix_fmt yuv420p seg1.mp4
ffmpeg -y -v error -i scene2.png -vf "zoompan=z='min(zoom+0.0009,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=128:s=1080x1920:fps=30" -t 4.25 -c:v libx264 -pix_fmt yuv420p seg2.mp4
ffmpeg -y -v error -i scene3.png -vf "zoompan=z='min(zoom+0.0009,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=128:s=1080x1920:fps=30" -t 4.25 -c:v libx264 -pix_fmt yuv420p seg3.mp4
ffmpeg -y -v error -i scene4.png -vf "zoompan=z='min(zoom+0.0009,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=123:s=1080x1920:fps=30" -t 4.10 -c:v libx264 -pix_fmt yuv420p seg4.mp4

# 2. Concat scenes into the ad body (16.85 s)
printf "file 'seg1.mp4'\nfile 'seg2.mp4'\nfile 'seg3.mp4'\nfile 'seg4.mp4'\n" > concat.txt
ffmpeg -y -v error -f concat -safe 0 -i concat.txt -c copy base.mp4

# 3. Final composite: badge from frame 0 until the card, card over the
# last 2.5 s with blur/desat easing in, referral code typed once the
# field rests. Recipe from make.fun's press pack llms.txt.
W=1080; H=1920; LEN=2.5; REST=1.433; CX=210; CY=1232; CW=5; CH=78; MID=1271; SIZE=62
D=$(ffprobe -v error -show_entries format=duration -of csv=p=0 base.mp4)
T=$(awk "BEGIN{print $D-$LEN}")
echo "base duration=$D card starts at T=$T code at $(awk "BEGIN{print $T+$REST}")"
ffmpeg -y -v error -i base.mp4 -c:v libvpx-vp9 -i assets/card-9x16.webm -i voice.mp3 -i assets/badge-9x16.png -filter_complex "
[0:v]scale=$W:$H:force_original_aspect_ratio=increase,crop=$W:$H,setsar=1,fps=60,format=yuva420p,split[clip][soft];
[soft]gblur=sigma=28,eq=saturation=0.35,fade=t=in:st=$T:d=0.8:alpha=1[soft];
[clip][soft]overlay[bg];
[bg][3:v]overlay=0:0:enable='lt(t,$T)'[bg2];
[1:v]format=yuva420p,setpts=PTS-STARTPTS+$T/TB[card];
[bg2][card]overlay=eof_action=pass,
drawbox=x=$CX-2:y=$CY-2:w=$CW+4:h=$CH+4:color=white:t=fill:enable='gte(t,$T+$REST)',
drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf:text='112z8vbj':fontsize=$SIZE:fontcolor=0x191419:x=$CX:y=$MID-(ascent-descent)/2:enable='gte(t,$T+$REST)'[v]" \
  -map '[v]' -map '2:a' -c:v libx264 -pix_fmt yuv420p -crf 18 -c:a aac -movflags +faststart -shortest ad.mp4

ffprobe -v error -show_entries format=duration,size -of default=noprint_wrappers=1 ad.mp4
ffmpeg -y -v error -ss 0.5 -i ad.mp4 -frames:v 1 first-frame.png
ffmpeg -y -v error -sseof -0.1 -i ad.mp4 -frames:v 1 last-frame.png
ffmpeg -y -v error -ss 8 -i ad.mp4 -frames:v 1 mid-frame.png
echo BUILD_DONE
