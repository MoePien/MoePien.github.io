# Blog drafting workflow

Drafts live in `drafts/` and are ignored by Git, so they are not published or exposed through the public repository.

## Edit and preview

```bash
./scripts/preview-post.sh drafts/good-stage-1-init.md
```

Open <http://localhost:4000/>. The draft opens directly and rebuilds whenever the Markdown source, post template, or stylesheet changes. Stop it with `Ctrl+C`.

To render once without starting a server:

```bash
./scripts/preview-post.sh drafts/good-stage-1-init.md --build-only
```

## Collaborating with Codex

- The Markdown draft is the source of truth.
- Ask for a review, reordering, copy edit, table cleanup, or a deliberately rewritten section.
- Unless explicitly requested, edits should preserve the author's claims, numbers, terminology, and voice.
- Draft work stays local. Publishing, committing, or pushing requires an explicit request.

## Publishing later

When the post is ready, render it into `blog/<slug>/index.html`, remove the draft/noindex marker, add it to `blog.html`, then commit and push those publication files.
