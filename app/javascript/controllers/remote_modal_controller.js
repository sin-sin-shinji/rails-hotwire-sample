import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="remote-modal"
export default class extends Controller {
  connect() {
    // モーダルが接続されたときに自動的に開く
    this.element.showModal();

    // モーダルが閉じられたときのイベントリスナーを追加
    this.element.addEventListener('close', this.handleClose.bind(this));
  }

  disconnect() {
    // コントローラーが切断されるときにイベントリスナーを削除
    this.element.removeEventListener('close', this.handleClose.bind(this));
  }

  handleClose() {
    // モーダルが閉じられたときにモーダル要素を削除
    this.element.remove();
  }
}
