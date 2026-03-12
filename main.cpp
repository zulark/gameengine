#include "imgui.h"
#include "imgui-SFML.h"
#include <SFML/Graphics.hpp>
#include <SFML/System/Clock.hpp>

int main() {
    // 1. Inicialização da Janela (SFML)
    sf::RenderWindow window(sf::VideoMode({800, 600}), "Template Base SFML 3 + ImGui");
    window.setFramerateLimit(60);

    // 2. Inicialização do ImGui
    if (!ImGui::SFML::Init(window)) return -1;
    sf::Clock deltaClock;

    // 3. Loop Principal (O "WindowShouldClose" do SFML)
    while (window.isOpen()) {
        
        // --- PROCESSAMENTO DE EVENTOS (Input) ---
        while (const std::optional<sf::Event> event = window.pollEvent()) {
            // O ImGui precisa ler o mouse/teclado antes do jogo
            ImGui::SFML::ProcessEvent(window, *event);

            // Se clicar no X da janela, fecha o programa
            if (event->is<sf::Event::Closed>()) {
                window.close();
            }
        }

        // --- ATUALIZAÇÃO (Update) ---
        // Alimenta o ImGui com o tempo que passou desde o último frame
        ImGui::SFML::Update(window, deltaClock.restart());

        // Crie suas janelas de interface gráfica aqui
        ImGui::Begin("Debug");
        ImGui::Text("Sistema Base Operacional.");
        ImGui::End();

        // Lógica de atualização do seu jogo iria aqui...

        // --- RENDERIZAÇÃO (Draw) ---
        // a) Limpa o frame anterior (fundo cinza escuro)
        window.clear(sf::Color(30, 30, 30)); 

        // b) Desenhe os gráficos do SFML aqui (ex: window.draw(jogador);)
        
        // c) Desenha a interface gráfica por cima do jogo
        ImGui::SFML::Render(window); 

        // d) Mostra o frame construído na tela
        window.display();
    }

    // 4. Limpeza de Memória
    ImGui::SFML::Shutdown();
    return 0;
}