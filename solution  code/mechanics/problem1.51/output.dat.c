#include <stdio.h>
#include <math.h>

#define G 9.81     // 重力加速度
#define R 5.0      // ハーフパイプの半径 (m)
#define DT 0.01    // 時間刻み
#define STEPS 2000 // シミュレーションステップ数

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

// Runge-Kutta法による数値解法
void rk4(double (*f)(double, double, double), double *t, double *phi, double *phidot, double dt)
{
    double k1_phi, k2_phi, k3_phi, k4_phi;
    double k1_phidot, k2_phidot, k3_phidot, k4_phidot;

    k1_phi = dt * (*phidot);
    k1_phidot = dt * f(*t, *phi, *phidot);

    k2_phi = dt * (*phidot + 0.5 * k1_phidot);
    k2_phidot = dt * f(*t + 0.5 * dt, *phi + 0.5 * k1_phi, *phidot + 0.5 * k1_phidot);

    k3_phi = dt * (*phidot + 0.5 * k2_phidot);
    k3_phidot = dt * f(*t + 0.5 * dt, *phi + 0.5 * k2_phi, *phidot + 0.5 * k2_phidot);

    k4_phi = dt * (*phidot + k3_phidot);
    k4_phidot = dt * f(*t + dt, *phi + k3_phi, *phidot + k3_phidot);

    *phi += (k1_phi + 2.0 * k2_phi + 2.0 * k3_phi + k4_phi) / 6.0;
    *phidot += (k1_phidot + 2.0 * k2_phidot + 2.0 * k3_phidot + k4_phidot) / 6.0;
    *t += dt;
}

// 振り子の運動方程式
double pendulum(double t, double phi, double phidot)
{
    return -(G / R) * sin(phi);
}

int main()
{
    double t = 0.0, phi = M_PI / 2, phidot = 0.0; // 初期条件
    FILE *fp = fopen("output.dat", "w"); // データファイルを開く
    if (fp == NULL) {
        perror("Failed to open file");
        return 1;
    }
    fprintf(fp, "Time (s), Phi (rad)\n");
    for (int i = 0; i < STEPS; i++)
    {
        fprintf(fp, "%f, %f\n", t, phi); // 時間と角度をファイルに出力
        rk4(pendulum, &t, &phi, &phidot, DT);
    }
    fclose(fp); // ファイルを閉じる
    return 0;
}
