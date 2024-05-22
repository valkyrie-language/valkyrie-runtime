use std::path::Path;
use nyar_runtime::NyarVM;


#[tokio::test]
async fn test_v_table() -> anyhow::Result<()> {
    let path = Path::new(env!("CARGO_MANIFEST_DIR")).join("tests/v-table.wat");
    let wast = std::fs::read_to_string(&path)?;
    NyarVM::load_wast(&wast).await?;
    Ok(())
}


#[tokio::test]
async fn test_yield() -> anyhow::Result<()> {
    let here = Path::new(env!("CARGO_MANIFEST_DIR"));
    NyarVM::load_path(&here.join("tests/yield.wat")).await?;
    Ok(())
}
