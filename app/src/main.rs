use actix_web::{get, App, HttpResponse, HttpServer, Responder};

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().json(serde_json::json!({
        "message": "Привет от Rust-сервера!"
    }))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("Запуск сервера на порту 8080");

    // Сервер слушает только локальный адрес
    HttpServer::new(|| {
        App::new()
            .service(hello)
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}