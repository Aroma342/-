#include <stdio.h>
#include <math.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

// 定数
#define R 5.0
#define G 9.8
// 定数
#define R 5.0
#define G 9.8

// 微分方程式の計算関数
void derivatives(double t, double phi[], double dphi[])
{
    dphi[0] = phi[1];
    dphi[1] = -(G / R) * sin(phi[0]);
}

// ルンゲ＝クッタ法（4次）
void rungeKutta(double t0, double phi[], double t_end, double dt)
{
    FILE *fp = fopen("output.dat", "w"); // 結果を保存するファイル
    if (fp == NULL)
    {
        printf("ファイルを開けませんでした\n");
        return;
    }

    int n = (int)((t_end - t0) / dt);
    for (int i = 0; i < n; i++)
    {
        double k1[2], k2[2], k3[2], k4[2], phi_temp[2];

        derivatives(t0, phi, k1);
        for (int j = 0; j < 2; j++)
        {
            phi_temp[j] = phi[j] + 0.5 * dt * k1[j];
        }

        derivatives(t0 + 0.5 * dt, phi_temp, k2);
        for (int j = 0; j < 2; j++)
        {
            phi_temp[j] = phi[j] + 0.5 * dt * k2[j];
        }

        derivatives(t0 + 0.5 * dt, phi_temp, k3);
        for (int j = 0; j < 2; j++)
        {
            phi_temp[j] = phi[j] + dt * k3[j];
        }

        derivatives(t0 + dt, phi_temp, k4);

        for (int j = 0; j < 2; j++)
        {
            phi[j] = phi[j] + (dt / 6.0) * (k1[j] + 2 * k2[j] + 2 * k3[j] + k4[j]);
        }

        t0 += dt;

        // ファイルに時間と角度を出力
        fprintf(fp, "%.2f %.4f\n", t0, phi[0]);
    }

    fclose(fp); // ファイルを閉じる
}

int main()
{
    // 初期条件
    double phi[2] = {0.11 * M_PI, 0.0}; // 初期角度と初期角速度
    double t0 = 0.0;                    // 開始時間
    double t_end = 10.0;                // 終了時間
    double dt = 0.01;                   // タイムステップ

    // ルンゲ＝クッタ法の実行
    rungeKutta(t0, phi, t_end, dt);

    return 0;
}
