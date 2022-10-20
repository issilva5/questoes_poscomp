import json
import requests
import os

path = os.getcwd()


def send(year):
    folder = os.listdir(path + '/' + year)

    for json_path in folder:
        if json_path == 'images':
            continue

        with open(year + '/' + json_path) as json_file:
            questao = json.load(json_file)
            questao_json = {
                'area': questao['Componente'],
                'subarea': questao['Subarea'],
                'numero': int(questao["Numero"]),
                'ano': int(questao['Ano']),
                'resposta': int(questao['Resposta']),
                'alternativas': questao['Alternativas'],
                'imagens': {'enunciado': questao['Imagens'], 'alternativa_a': [], 'alternativa_b': [],
                            'alternativa_c': [], 'alternativa_d': [], 'alternativa_e': []},
                'enunciado': questao['Enunciado']
            }

            r = requests.post(
                'http://localhost:8060/questao/', json=questao_json)
            if r.status_code == 201:
                print('year: ' + year + ', json_path: ' + json_path)


send('2016')
send('2017')
send('2018')
send('2019')
