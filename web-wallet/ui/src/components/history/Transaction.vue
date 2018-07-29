<template>
  <div class="transaction">
    <img src="static/img/icons/favicon-96x96.png">
    <div class="transaction-info">
      <h2>Heading</h2>
      <p>{{ transaction.description }}</p>
      <div class="details">
        <span v-if="transaction.state === 'approved'" class="approved">
          <v-icon>check_circle_outline</v-icon> Completed
        </span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'name',
  props: ['transaction'],
  created () {
    console.log(this.transaction)
  }
}
</script>

<style>
.transaction {
  display: flex;
  align-items: center;
  padding: 5px;
}
.transaction img {
  width: 45px;
  height: 45px;
  margin: 4px 10px;
}
.transaction-info {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  margin: 0 5px;
}
.transaction-info h2 {
  font-size: 15px;
  font-weight: normal;
}
.transaction-info p {
  margin-bottom: 0px;
  font-size: 12px;
}
.details span {
  display: flex;
  align-items: center;
  font-size: 10px;
}
.details span.approved, .details i {
  color: #689F38 !important;
}
.details span.approved {
  text-transform: uppercase;
}
</style>