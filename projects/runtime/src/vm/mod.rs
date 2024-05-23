use std::path::Path;

use wasmtime::{
    component::{Component, ComponentNamedList, Instance, Lift, Linker, Lower, ResourceTable},
    Config, Engine, Store,
};
use wasmtime_wasi::{WasiCtx, WasiCtxBuilder, WasiView};

use crate::{host::NyarExtension, vm::building::ContextView};

mod building;

pub struct NyarVM {
    store: Store<ContextView>,
    instance: Instance,
}

impl NyarVM {
    pub async fn invoke<I, O>(&mut self, name: &str, args: I) -> anyhow::Result<O>
    where
        I: ComponentNamedList + Lower + Send + Sync,
        O: ComponentNamedList + Lift + Send + Sync,
    {
        let f = self.instance.get_typed_func(&mut self.store, name)?;
        f.call_async(&mut self.store, args).await
    }
}
