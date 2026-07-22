# MarkdownWidgetBlock

Loads markdown from an **asset file** — handy for content-heavy slides you
want to edit without touching Dart code.

## What you get

- Headings, emphasis, lists, links
- Syntax-highlighted code blocks
- This slide scrolls with the mouse wheel (`NonZoomableSlide`)

## Code example

```rust
#[no_mangle]
pub extern "system" fn Java_Demo_add(_env: JNIEnv, _class: JClass, a: jint, b: jint) -> jint {
    a + b
}
```

> Tip: keep one markdown file per slide and name them after the slide.
