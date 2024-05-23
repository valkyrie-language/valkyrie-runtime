use std::path::Path;

use wasmtime::{
    component::{Component, Instance, Linker, ResourceTable},
    Config, Engine, Store,
};
use wasmtime::component::{ComponentNamedList,  Lift, Lower};
use wasmtime_wasi::{WasiCtx, WasiCtxBuilder, WasiView};

use crate::{host::NyarExtension};
use crate::vm::building::ContextView;

mod building;

pub struct NyarVM {
    store: Store<ContextView>,
    instance: Instance,
}

impl NyarVM {
    pub async fn invoke<Params, Results>(&mut self, name: &str, args: Params) -> anyhow::Result<Results> where
        Params: ComponentNamedList + Lower  + Send + Sync,
        Results: ComponentNamedList + Lift  + Send + Sync {

        let f = self.instance.get_typed_func(&mut self.store, name)?;
        f.call_async(&mut self.store, args).await
    }
}