// Prevents additional console window on Windows in release, DO NOT REMOVE!!
// TODO: Uncomment on release
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]


use async_recursion::async_recursion;

use local_ip_address::local_ip;
use tiny_http::{Server, Response};
use enigo::*;




#[tauri::command]
#[async_recursion]
async fn start_wifi_server() {

    let local_ip = match local_ip() {
        Ok(value) => value,
        Err(_) => return,
    };

    let mut enigo = Enigo::new();

    let server = match Server::http(format!("{}:1138", local_ip.to_string())) {
        Ok(value) => value,
        Err(_) => return,
    };

    println!("Local IP address: {:?}", local_ip);
    println!("Server is running on address: {:?}", server.server_addr());

    for request in server.incoming_requests() {
        
        let response_message: String = match request.url().split('/').nth(1) {
            Some("") => String::from("ok"),
            Some("start") => {
                enigo.key_down(Key::Control);
                enigo.key_down(Key::Shift);
                enigo.key_down(Key::F5);
                enigo.key_up(Key::F5);
                enigo.key_up(Key::Shift);
                enigo.key_up(Key::Control);
                String::from("start")
            },
            Some("stop") => {
                enigo.key_click(Key::Escape);
                String::from("stop")
            },
            Some("back") => {
                enigo.key_click(Key::LeftArrow);
                String::from("back")
            },
            Some("forward") => {
                enigo.key_click(Key::RightArrow);
                String::from("forward")
            },
            Some("mouse") => {
                match request.url().split('/').nth(2) {
                    Some("get") => format!(
                        "{}&{}",
                        enigo.mouse_location().0.to_string(),
                        enigo.mouse_location().1.to_string(),
                    ),
                    Some("left") => {
                        enigo.mouse_click(MouseButton::Left);
                        String::from("mouse click left (ok)")
                    },
                    Some("right") => {
                        enigo.mouse_click(MouseButton::Right);
                        String::from("mouse click right (ok)")
                    },
                    Some(parameters) => {
                        if parameters.contains('&') {
                            let x: i32 = match parameters.split('&').nth(0).unwrap().parse() {
                                Ok(value) => value,
                                Err(_) => 0,
                            };
                            let y: i32 = match parameters.split('&').nth(1).unwrap().parse() {
                                Ok(value) => value,
                                Err(_) => 0,
                            };
                            enigo.mouse_move_relative(x, y);
                            String::from("mouse (ok)")
                        } else {
                            String::from("mouse (not formatted properly)")
                        }
                    }
                    _ => String::from("error: no valid request received"),
                }
            },
            _ => String::from("error: no valid request received"),
        }.to_lowercase();
        let response = Response::from_string(response_message.clone());

        //const REQUEST_URLS: Vec<String> = vec![];

        match request.respond(response) {
            Ok(()) => println!("{}", response_message),
            Err(err) => println!("Error:\n{}", err),
        };
    }

    start_wifi_server().await;
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![start_wifi_server])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
