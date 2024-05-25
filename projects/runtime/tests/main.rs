use nyar_runtime::NyarVM;
use std::path::Path;

#[ignore]
#[tokio::test]
async fn test_v_table() -> anyhow::Result<()> {
    let path = Path::new(env!("CARGO_MANIFEST_DIR")).join("tests/v-table.wat");
    let wast = std::fs::read_to_string(&path)?;
    NyarVM::load_wast(&wast).await?;
    Ok(())
}

#[ignore]
#[tokio::test]
async fn test_yield() -> anyhow::Result<()> {
    let here = Path::new(env!("CARGO_MANIFEST_DIR"));
    NyarVM::load_path(&here.join("tests/yield.wat")).await?;
    Ok(())
}

#[tokio::test]
async fn test_empty_kont() -> anyhow::Result<()> {
    let here = Path::new(env!("CARGO_MANIFEST_DIR"));
    NyarVM::load_path(&here.join("tests/kont.wat")).await?;
    Ok(())
}


#[tokio::test]
async fn test_switch() -> anyhow::Result<()> {
    let here = Path::new(env!("CARGO_MANIFEST_DIR"));
    NyarVM::load_path(&here.join("tests/switch.wat")).await?;
    Ok(())
}
