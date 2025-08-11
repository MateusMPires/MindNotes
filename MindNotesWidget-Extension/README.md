# MindNotes Widget Extension

## Descrição
Este widget permite aos usuários adicionar novos pensamentos rapidamente diretamente da tela inicial do iOS, sem precisar abrir o app.

## Funcionalidades
- **Botão de Adicionar**: Um botão circular com ícone de "+" que, quando tocado, abre o app na tela de novo pensamento
- **Deep Linking**: Utiliza o esquema de URL `mindnotes://new-thought` para navegar diretamente para a tela de criação
- **Design Minimalista**: Interface limpa e elegante que segue o design do app principal

## Arquivos Principais
- `MindNotesWidget.swift` - Configuração principal do widget
- `MindNotesWidgetBundle.swift` - Bundle que registra o widget
- `MindNotesTimelineProvider.swift` - Fornece as entradas da timeline
- `WidgetExtensions.swift` - Extensões e constantes úteis
- `WidgetPreviews.swift` - Previews para desenvolvimento

## Como Funciona
1. Usuário toca no widget na tela inicial
2. O sistema iOS detecta o `widgetURL` com o esquema `mindnotes://new-thought`
3. O app MindNotes é aberto e recebe a URL via `onOpenURL`
4. O app navega automaticamente para a tela de novo pensamento

## Requisitos
- iOS 17.0+
- WidgetKit framework
- Esquema de URL configurado no app principal (`mindnotes://`)

## Personalização
O widget pode ser facilmente personalizado alterando:
- Cores do gradiente de fundo
- Ícone do botão
- Texto descritivo
- Tamanhos e espaçamentos 