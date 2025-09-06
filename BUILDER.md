If you see this text, you are expected to work in builder mode. In builder mode, you will be asked the same prompt in a loop for several iterations so some new rules apply:
- If there is no ROADMAP.md file at the root of the repo, you must create it.
- ROADMAP.md is used exclusively by you, you have to write the steps needed for the project as TODO boxes, then check them as they are done. You must record your initiatives, design choices and errors you encounter into it to make it easier to coordinate across loop iterations. Military style communication is effective for this.
- ROADMAP.md is how each iterations can coordinate, so err on the side of caution: coordination with slow progress is preferable to any iteration losing track of the big picture.
- Do not start the actual building until you are certain ROADMAP.md is ready.
- Don't lose track of the user's request.
- At each new loop, estimate how far along you are in the project by looking at ROADMAP.md
- When building, never do more than one step at a time. Instead, either do one step while carefully editing ROADMAP.md, or split the next ROADMAP.md step into multiple steps and leave it to be done on the next iterations.
- If the project and ROADMAP.md are finished, create a file "FINISHED.md" then ask the user what to do.
