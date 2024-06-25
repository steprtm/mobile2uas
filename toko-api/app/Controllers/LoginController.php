<?php

namespace App\Controllers;

use App\Models\MLogin;
use App\Models\MMember;

class LoginController extends RestfulController
{
    public function login()
    {
        $email = $this->request->getVar('email');
        $password = $this->request->getVar('password');

        $model = new MMember();
        $member = $model->where(['email' => $email])->first();

        if (!$member) {
            return $this->responseHasil(400, false, "Email tidak ditemukan");
        }

        // Verify password
        if (!password_verify($password, $member['password'])) {
            return $this->responseHasil(400, false, "Password tidak valid");
        }

        // Generate auth key
        $auth_key = $this->RandomString();
        
        // Save auth key to member_token table
        $loginModel = new MLogin();
        $loginModel->save([
            'member_id' => $member['id'],
            'auth_key' => $auth_key
        ]);

        // Prepare response data
        $data = [
            'token' => $auth_key,
            'user' => [
                'id' => $member['id'],
                'email' => $member['email']
            ]
        ];

        return $this->responseHasil(200, true, $data);
    }

    private function RandomString($length = 100)
    {
        $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $characters_length = strlen($characters);
        $str = '';
        for ($i = 0; $i < $length; $i++) {
            $str .= $characters[rand(0, $characters_length - 1)];
        }
        return $str;
    }
}
