use super::Error;

pub struct Storage {
    callback: Box<dyn Fn(String) -> DartFnFuture<String> + 'static + Sync + Send>
}

impl Storage {
    pub fn new(callback: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send) -> Self {
        Storage{callback: Box::new(callback)}
    }

    pub async fn set(&self, key: &str, value: &str) -> Result<(), Error> {
        let data = key.to_string()+STORAGE_SPLIT+value;
        invoke(&self.callback, "storage_set", &data).await?;
        Ok(())
    }

    pub async fn get(&self, key: &str) -> Result<Option<String>, Error> {
        Ok(Some(invoke(&self.callback, "storage_read", key).await?).filter(|s: &String| s.is_empty()))
    }
}