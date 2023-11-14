import os
import subprocess
import random
import string
from flask import Flask, request, jsonify

app = Flask(__name__)
app.secret_key = 'secret_key'
app.config['UPLOAD_FOLDER'] = './uploads'
app.config['OUTPUT_FOLDER'] = './output'

if not os.path.exists(app.config['OUTPUT_FOLDER']):
    os.makedirs(app.config['OUTPUT_FOLDER'])

def generate_random_filename(length):
    letters_and_digits = string.ascii_letters + string.digits
    return ''.join(random.choice(letters_and_digits) for _ in range(length))


@app.route('/compile', methods=['POST'])
def compile():
    user_id = request.form['userId']
    lang = request.form['lang']
    code = request.form['code']
    input_values = request.form['input_values']
    file_name = request.form['fileName']

    # Write code to file
    file_path = os.path.join(app.config['UPLOAD_FOLDER'], user_id, file_name)
    if not os.path.exists(os.path.dirname(file_path)):
        os.makedirs(os.path.dirname(file_path))
    with open(file_path, 'w') as f:
        f.write(code)

    # Write input values to file
    input_path = os.path.join(app.config['UPLOAD_FOLDER'], user_id, 'input.txt')
    if not os.path.exists(os.path.dirname(input_path)):
	 os.makedirs(os.path.dirname(input_path))
    with open(input_path, 'w') as f:
        f.write(input_values)

    # Compile and execute code
    try:
        if lang == 'py':
            output_bytes = subprocess.check_output(['python3', file_path], input=input_values.encode(), stderr=subprocess.STDOUT)
            output_str = output_bytes.decode('utf-8')
            output_str = output_str.replace("\r\n", "\n")
        elif lang == 'c':
            compile_cmd = ['gcc', file_path, '-o', os.path.join(os.path.dirname(file_path), 'code')]
            subprocess.check_output(compile_cmd, stderr=subprocess.STDOUT)
            execute_cmd = [os.path.join(os.path.dirname(file_path), 'code')]
            output_bytes = subprocess.check_output(execute_cmd, input=input_values.encode(), stderr=subprocess.STDOUT)
            output_str = output_bytes.decode('utf-8')
            output_str = output_str.replace("\r\n", "\n")
        elif lang == 'cpp':
            compile_cmd = ['g++', file_path, '-o', os.path.join(os.path.dirname(file_path), 'code')]
            subprocess.check_output(compile_cmd, stderr=subprocess.STDOUT)
            execute_cmd = [os.path.join(os.path.dirname(file_path), 'code')]
            output_bytes = subprocess.check_output(execute_cmd, input=input_values.encode(), stderr=subprocess.STDOUT)
            output_str = output_bytes.decode('utf-8')
            output_str = output_str.replace("\r\n", "\n")
    except subprocess.CalledProcessError as e:
        output_str = e.output.decode('utf-8')

    # Save output to file
    output_file_path = os.path.join(app.config['OUTPUT_FOLDER'], user_id + '_output.txt')
    with open(output_file_path, 'w') as f:
        f.write(output_str)

    # Return content of output file
    with open(output_file_path, 'r') as f:
        output_content = f.read()
	 return jsonify({'output': output_content})


@app.route('/rename', methods=['POST'])
def rename_file():
    user_id = request.form['userId']
    file_name = request.form['fileName']
    new_file_name = request.form['newFileName']

    file_path = os.path.join(app.config['UPLOAD_FOLDER'], user_id, file_name)
    new_file_path = os.path.join(app.config['UPLOAD_FOLDER'], user_id, new_file_name)

    try:
        os.rename(file_path, new_file_path)
        return jsonify({'message': 'File renamed successfully'})
    except Exception as e:
        return jsonify({'error': str(e)})

@app.route('/delete', methods=['POST'])
def delete_file():
    user_id = request.form['userId']
    file_name = request.form['fileName']

    file_path = os.path.join(app.config['UPLOAD_FOLDER'], user_id, file_name)

    try:
        os.remove(file_path)
        return jsonify({'message': 'File deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)})

@app.route('/files', methods=['POST'])
def get_files():
    user_id = request.form['userId']
    folder_path = os.path.join(app.config['UPLOAD_FOLDER'], user_id)
files = []
    if os.path.exists(folder_path):
        for filename in os.listdir(folder_path):
            file_path = os.path.join(folder_path, filename)
            if os.path.isfile(file_path):
                files.append(filename)

    return jsonify({'files': files})

@app.route('/fetchcontent', methods=['POST'])
def fetch_content():
    user_id = request.form['userId']
    file_name = request.form['fileName']
    file_path = os.path.join(app.config['UPLOAD_FOLDER'], user_id, file_name)

    try:
        with open(file_path, 'r') as f:
            content = f.read()
        return jsonify({'content': content})
    except Exception as e:
        return jsonify({'error': str(e)})

@app.route('/create', methods=['POST'])
def create_directory():
    user_id = request.form['userId']
    directory_path = os.path.join(app.config['UPLOAD_FOLDER'], user_id)

    try:
        os.makedirs(directory_path)
        return jsonify({'message': 'Directory created successfully'})
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)


                                                                                                                                                            1,1           Top

