#include <stdio.h>
#include <math.h>

#define G 9.81  // 重力加速度
#define R 5.0   // ハーフパイプの半径 (m)
#define DT 0.01 // 時間刻み
#define STEPS 1500 // シミュレーションステップ数 (15秒)

void rk4(double (*f)(double, double, double), double *t, double *phi, double *phidot, double dt) {
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

double pendulum_nonlinear(double t, double phi, double phidot) {
    return -(G / R) * sin(phi);
}

double pendulum_linear(double t, double phi, double phidot) {
    return -(G / R) * phi;
}

int main() {
    double t1 = 0.0, phi1 = M_PI / 2, phidot1 = 0.0;  // 初期条件: 非線形
    double t2 = 0.0, phi2 = M_PI / 2, phidot2 = 0.0;  // 初期条件: 線形

    printf("Time (s), Nonlinear Phi (rad), Linear Phi (rad)\n");
    for (int i = 0; i < STEPS; i++) {
        printf("%f, %f, %f\n", t1, phi1, phi2);
        rk4(pendulum_nonlinear, &t1, &phi1, &phidot1, DT);
        rk4(pendulum_linear, &t2, &phi2, &phidot2, DT);
    }
    return 0;
}
