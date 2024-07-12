import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import reports.report1 as report1

# Importa otros reportes si es necesario

# Inicializa la aplicación Dash
app = dash.Dash(__name__, suppress_callback_exceptions=True) # Esta línea ocultará los controles inferiores

# Define el diseño de tu aplicación
app.layout = html.Div([
    dcc.Location(id='url', refresh=False),
    html.Div(id='page-content')
])

# Callback para cambiar entre páginas (informes)
@app.callback(
    Output('page-content', 'children'),
    [Input('url', 'pathname')]
)
def display_page(pathname):
    if pathname == '/report1':
        return report1.layout
    else:
        return '404 - Página no encontrada'

# Ejecuta la aplicación
if __name__ == '__main__':
    app.run_server(debug=True)
